import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.core.IsNull.notNullValue;

public class AuthIntegrationTest {

    @BeforeAll
    static void setUp(){
        RestAssured.baseURI = "http://localhost:4004";
    }

    @Test
    public void shouldReturnOKWithValidToken() {

        //act
        //assert

        String loginPayload = """
                {
                    "email": "testuser@test.com",
                    "password": "password123"
                }
                """;

        Response response = given()
                //arrange
                .contentType("application/json")
                .body(loginPayload)
                //act
                .when()
                .post("/auth/login")
                //assert
                .then()
                .statusCode(200)
                .body("token", notNullValue())
                .extract().response();

        System.out.println("Generated Token: " + response.jsonPath().getString("token"));
    }

    @Test
    public void shouldReturnUnauthorizedOnInvalidToken() {

        //act
        //assert

        String loginPayload = """
                {
                    "email": "invlid@test.com",
                    "password": "wrongpassword123"
                }
                """;

        given()
                //arrange
                .contentType("application/json")
                .body(loginPayload)
                //act
                .when()
                .post("/auth/login")
                //assert
                .then()
                .statusCode(401);
    }

}
