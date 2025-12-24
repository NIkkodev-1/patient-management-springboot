#!/bin/bash
set -e

# LocalStack configuration
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_REGION=us-east-1
LOCALSTACK_ENDPOINT="http://localhost:4566"
STACK_NAME="patient-management"
TEMPLATE_FILE="./cdk.out/localstack.template.json"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking if LocalStack is running...${NC}"
if ! curl -s "$LOCALSTACK_ENDPOINT/_localstack/health" > /dev/null 2>&1; then
    echo -e "${RED}Error: LocalStack is not running at $LOCALSTACK_ENDPOINT${NC}"
    echo "Please start LocalStack first with: localstack start"
    exit 1
fi
echo -e "${GREEN}LocalStack is running${NC}"

echo -e "${YELLOW}Checking if template file exists...${NC}"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file not found at $TEMPLATE_FILE${NC}"
    echo "Please run 'cdk synth' first to generate the template"
    exit 1
fi
echo -e "${GREEN}Template file found${NC}"

echo -e "${YELLOW}Deleting existing stack...${NC}"
aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation delete-stack \
    --stack-name "$STACK_NAME" 2>/dev/null || true

echo -e "${YELLOW}Waiting for stack deletion...${NC}"
aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation wait stack-delete-complete \
    --stack-name "$STACK_NAME" 2>/dev/null || true

echo -e "${YELLOW}Deploying stack...${NC}"
if aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM; then

    echo -e "${GREEN}Stack deployed successfully!${NC}"

    echo -e "${YELLOW}Checking stack outputs...${NC}"
    aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --query 'Stacks[0].Outputs' \
        --output table

    echo -e "${YELLOW}Checking load balancer...${NC}"
    ALB_DNS=$(aws --endpoint-url="$LOCALSTACK_ENDPOINT" elbv2 describe-load-balancers \
        --query "LoadBalancers[0].DNSName" --output text 2>/dev/null) || ALB_DNS=""

    if [ -n "$ALB_DNS" ] && [ "$ALB_DNS" != "None" ]; then
        echo -e "${GREEN}Load Balancer DNS: $ALB_DNS${NC}"
    else
        echo -e "${YELLOW}No ALB created${NC}"
    fi

else
    echo -e "${RED}Failed to create/update the stack${NC}"
    echo -e "${YELLOW}Fetching error details...${NC}"

    # Get failed resources with detailed error messages
    aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation describe-stack-events \
        --stack-name "$STACK_NAME" \
        --query 'StackEvents[?ResourceStatus==`CREATE_FAILED` || ResourceStatus==`UPDATE_FAILED` || ResourceStatus==`ROLLBACK_IN_PROGRESS`].[Timestamp,LogicalResourceId,ResourceType,ResourceStatusReason]' \
        --output table

    echo -e "${YELLOW}Full stack status:${NC}"
    aws --endpoint-url="$LOCALSTACK_ENDPOINT" cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --query 'Stacks[0].[StackStatus,StackStatusReason]' \
        --output table 2>/dev/null || echo "Stack not found"

    exit 1
fi