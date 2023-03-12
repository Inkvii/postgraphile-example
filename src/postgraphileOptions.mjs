import PgSimplifyInflectorPlugin from "@graphile-contrib/pg-simplify-inflector"
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter"

/**@type {import("postgraphile").PostGraphileOptions} */
export const postgraphileOptions = {
  subscriptions: true,
  watchPg: true,
  dynamicJson: true,
  setofFunctionsContainNulls: false,
  ignoreRBAC: false,
  ignoreIndexes: true,
  showErrorStack: "json",
  extendedErrors: ["hint", "detail", "errcode"],
  appendPlugins: [PgSimplifyInflectorPlugin, ConnectionFilterPlugin],
  exportGqlSchemaPath: "schema.graphql",
  graphiql: true,
  enhanceGraphiql: true,
  allowExplain(req) {
    // TODO: customise condition!
    return true
  },
  enableQueryBatching: true,
  legacyRelations: "omit",
  enableCors: true,
  graphileBuildOptions: {
    connectionFilterAllowNullInput: true,
  },
  pgDefaultRole: "unauthenticated",
  jwtSecret: "my-super-secret",
  // defines type that will be encoded to jwt on mutation response
  jwtPgTypeIdentifier: "registration.jwt_token",
}
