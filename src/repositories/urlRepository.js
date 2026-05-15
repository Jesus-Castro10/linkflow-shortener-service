import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} from "@aws-sdk/lib-dynamodb";

const docClient = DynamoDBDocumentClient.from(new DynamoDBClient({}));

export async function getByCode(code) {
  const { Item } = await docClient.send(
    new GetCommand({
      TableName: process.env.TABLE_NAME,
      Key: {
        PK: `CODE#${code}`,
        SK: "METADATA",
      },
    }),
  );

  return Item ?? null;
}

export async function save(code, longUrl) {
  await docClient.send(
    new PutCommand({
      TableName: process.env.TABLE_NAME,
      Item: {
        PK: `CODE#${code}`,
        SK: "METADATA",
        longUrl,
        createdAt: new Date().toISOString(),
      },
    }),
  );
}
