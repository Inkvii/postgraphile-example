import { postgraphile } from "postgraphile"
import dotenv from "dotenv"
import { postgraphileOptions } from "./postgraphileOptions.mjs"
import express from "express"

dotenv.config()

const middleware = postgraphile(process.env.DATABASE_URL, ["public", "registration"], postgraphileOptions)

const app = express()

function authorizationCheck(req, res, next) {
  console.log("Checking authorization of the request")
  console.log(req.headers)
  next()
}

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
