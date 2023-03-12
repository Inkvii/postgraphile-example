import PgSimplifyInflectorPlugin from "@graphile-contrib/pg-simplify-inflector"
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter"

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
  pgSettings(req) {
    /* TODO */
  },
  enableCors: true,
  graphileBuildOptions: {
    connectionFilterAllowNullInput: true,
  },
}
