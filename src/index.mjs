import { postgraphile } from "postgraphile"
import dotenv from "dotenv"
import { postgraphileOptions } from "./postgraphileOptions.mjs"
import express from "express"
import * as crypto from "crypto"

dotenv.config()


const middleware = postgraphile(process.env.DATABASE_URL, ["public", "registration"], postgraphileOptions)

const app = express()

function authorizationCheck(req, res, next) {
  console.log("Checking authorization of the request")
  console.log(req.headers)
  next()
}

app.use("/verifyToken", (req, res, next) => {
  console.log("verify token", req.body)
  const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXV0aGVudGljYXRlZCIsImV4cCI6MTY4NzExNDYyNSwidXNlcl9pZCI6MSwiaXNfYWRtaW4iOmZhbHNlLCJ1c2VybmFtZSI6ImFkbWluIiwiaWF0IjoxNjg3MTA4NjI0LCJhdWQiOiJwb3N0Z3JhcGhpbGUiLCJpc3MiOiJwb3N0Z3JhcGhpbGUifQ.tZ0OtsTYtrHzsQLbhY8YNBnZnc087UsIZ9p7s4MTEb8"
  const [header, payload, signature] = token.split(".")
  const [decodedHeader, decodedPayload] = token.split(".").map((part, index, array) => index < array.length - 1 ? Buffer.from(part, "base64url").toString() : part)

  const verifier = crypto.createHmac("sha-256", "my-super-secret").update([header, payload].join(".")).digest().toString("base64url")
  console.log("Parsed jwt", decodedHeader, decodedPayload)
  console.log("Signature from token", signature)
  console.log("Signature from verifier", verifier.toString())
  console.info("Does signature match?", signature === verifier.toString())

})
app.use("/graphql", authorizationCheck)
app.use(middleware)

const server = app.listen(process.env.PORT, () => {
  const address = server.address()
  if (typeof address !== "string") {
    const href = `http://localhost:${address.port}/graphiql`
    console.log(`PostGraphiQL available at ${href}`)
  } else {
    console.log(`PostGraphile listening on ${address}`)
  }
})
