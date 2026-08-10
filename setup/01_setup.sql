---- POC setup scripts for database, schema, and Git integration
USE POC1_DB;
CREATE SCHEMA IF NOT EXISTS POC_SCHEMA;
CREATE SCHEMA IF NOT EXISTS SOCCER;

---- Create the API integration required to create the 0git workspace.
drop secret POC1_DB.POC_SCHEMA.my_git_secret_new_tk

CREATE OR REPLACE SECRET POC1_DB.POC_SCHEMA.my_git_secret_new_tk1
  TYPE = password
  USERNAME = 'venkat-vs-id'
  PASSWORD = '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';

-- Create the API integration
CREATE OR REPLACE API INTEGRATION my_git_api_integration_tk1
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/venkat-vs-id')
  ALLOWED_AUTHENTICATION_SECRETS = (POC1_DB.POC_SCHEMA.my_git_secret_new_tk1)
  ENABLED = TRUE;

DESCRIBE INTEGRATION my_git_api_integration_tk1;


---- Create the API integration required to create the 0git workspace.
CREATE OR REPLACE SECRET POC1_DB.POC_SCHEMA.my_git_secret_classic_tk
  TYPE = password
  USERNAME = 'venkat-vs-id'
  PASSWORD = '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';

-- Create the API integration
CREATE OR REPLACE API INTEGRATION my_git_api_integration_classic_tk
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/venkat-vs-id')
  ALLOWED_AUTHENTICATION_SECRETS = (POC1_DB.POC_SCHEMA.my_git_secret_classic_tk)
  ENABLED = TRUE;

DESCRIBE INTEGRATION my_git_api_integration_classic_tk;

---- TEST
use database POC1_DB;
use schema POC_SCHEMA;

CREATE OR REPLACE GIT REPOSITORY test_git_repo_stage
  API_INTEGRATION = my_git_api_integration_classic_tk
  GIT_CREDENTIALS = my_git_secret_classic_tk
  ORIGIN = 'https://github.com/venkat-vs-id/Snowflake_poc1_git.git';

  ALTER GIT REPOSITORY test_git_repo_stage FETCH;