# GitHub Actions Practice Guide for Salesforce DevOps

Work through the stages in order. Stage 1 needs no Salesforce org at all.

## Tools to install on your machine

| Tool | Why | Check |
|------|-----|-------|
| Node.js 20+ | Runs lint and LWC Jest tests | `node -v` |
| Git | Version control | `git --version` |
| Salesforce CLI (`sf`) | Talk to Salesforce orgs | `sf --version` |
| VS Code + Salesforce Extension Pack | Editor | |
| GitHub account | Hosts the pipeline | |

Install the CLI: `npm install --global @salesforce/cli`

---

## Stage 1: First green pipeline (no org)

1. Run locally first:
   ```bash
   npm install
   npm run lint
   npm run test:unit
   ```
2. Create an empty repository on GitHub (e.g. `salesforce-devops-practice`). A public repo gives free Actions minutes.
3. Push the project:
   ```bash
   git init -b main
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/<your-username>/salesforce-devops-practice.git
   git push -u origin main
   ```
4. Open the **Actions** tab. `deploy-main.yml` runs the `test` job. The `deploy` job is skipped because org steps are not enabled yet. That is expected.

## Stage 2: Pull request workflow

```bash
git checkout -b feature/change-limit
# edit something small, e.g. DEFAULT_LIMIT in AccountService.cls
git commit -am "Change default limit"
git push -u origin feature/change-limit
```
Open a pull request on GitHub. `PR Validation` runs `lwc-quality`. Watch the checks appear on the PR.

**Break it on purpose:** change an assertion in `accountList.test.js`, push, and see the red check. Fix it and see it turn green. Reading failed logs is a core DevOps skill.

## Stage 3: Connect a real org (free Developer Edition)

1. Sign up for a free org at https://developer.salesforce.com/signup
2. Log in from the CLI:
   ```bash
   sf org login web --alias my-dev-org
   ```
3. Get the auth URL:
   ```bash
   sf org display --target-org my-dev-org --verbose
   ```
   Copy the value shown as **Sfdx Auth Url** (it starts with `force://`).
4. In GitHub: **Settings > Secrets and variables > Actions**
   - **Secrets** tab: New repository secret, name `SFDX_AUTH_URL`, value = the auth URL
   - **Variables** tab: New repository variable, name `ENABLE_ORG_STEPS`, value `true`
5. Open a new pull request. Now `validate-in-org` runs `sf project deploy validate` with all Apex tests. It checks the deployment without saving it to the org.
6. Merge the PR. `deploy-main.yml` deploys to the org. Check **Setup > Deployment Status** in the org to see it.

> Treat the auth URL like a password. Never commit it. Pull requests from forks do not receive secrets.

## Stage 4: Add protection and approvals

- **Branch protection:** Settings > Branches > add rule for `main`: require a pull request, require the status checks `Lint and LWC unit tests` and `Validate deployment and run Apex tests`.
- **Environment approval:** Settings > Environments > `production` > Required reviewers. The deploy job will now wait for your approval.

## Stage 5: Practice exercises

1. Add a new Apex class with a test, and see how code coverage affects deployment (75% required for production).
2. Add a second LWC with a Jest test.
3. Run the pipeline with a failing Apex test and read the error in the log.
4. Use `sf project deploy quick` after a successful validate to deploy without re-running tests.
5. Run the manual `scratch-org-ci.yml` workflow (needs a Dev Hub and secret `DEVHUB_AUTH_URL`).
6. Add a second org (UAT) with its own secret and an environment, and promote changes `dev -> uat -> prod`.
7. Add Salesforce Code Analyzer (PMD) for Apex static analysis.
8. Try **sfdx-git-delta** to deploy only changed files instead of the whole `force-app` folder.

## Running workflows on your machine (optional)

[`act`](https://github.com/nektos/act) runs GitHub Actions locally with Docker:
```bash
act pull_request -j lwc-quality
```
The org jobs need your secrets, so practise those on GitHub itself.

## Useful CLI commands

```bash
sf org list
sf project deploy start --source-dir force-app --target-org my-dev-org
sf project deploy validate --source-dir force-app --test-level RunLocalTests --target-org my-dev-org
sf apex run test --test-level RunLocalTests --target-org my-dev-org --code-coverage --result-format human
sf apex run --file scripts/apex/hello.apex --target-org my-dev-org
```
