import Config

config :canary_poc,
  ecto_repos: [CanaryPoc.Repo]

config :canary_poc, CanaryPoc.Repo,
  database: "canary_poc_repo",
  username: "user",
  password: "pass",
  hostname: "localhost",
  port: 6543

config :canary,
  repo: CanaryPoc.Repo
