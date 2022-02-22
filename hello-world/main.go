package main

import (
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Println("Lambda executed")

	return events.APIGatewayProxyResponse{
		Body:       "Hello",
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
