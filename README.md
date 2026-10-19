# Salesforce DevOps Practice Project

A small, standard **Salesforce DX (SFDX)** project for practising **GitHub Actions CI/CD**.
It has Apex (class, trigger, tests), a Lightning Web Component with Jest tests, and three pipelines.

## Project structure

```
salesforce-devops-practice/
├── .github/
│   ├── workflows/
│   │   ├── pr-validate.yml        # Runs on every pull request (lint, Jest, org validation)
│   │   ├── deploy-main.yml        # Runs on merge to main (deploy + tests)
│   │   └── scratch-org-ci.yml     # Advanced, manual: temporary scratch org test
│   └── pull_request_template.md
├── config/
│   └── project-scratch-def.json   # Scratch org definition
├── force-app/main/default/
│   ├── classes/                   # AccountService, AccountController, AccountServiceTest
│   ├── triggers/                  # AccountTrigger
│   └── lwc/
│       ├── accountList/           # LWC + __tests__/accountList.test.js
│       └── .eslintrc.json
├── manifest/package.xml           # Manifest for manifest-based deploys
├── scripts/apex/hello.apex        # Anonymous Apex sample
├── docs/PIPELINE_GUIDE.md         # Step-by-step practice guide  <-- start here
├── sfdx-project.json              # Core SFDX project file
├── package.json                   # Lint + Jest scripts
├── jest.config.js
├── .forceignore                   # What Salesforce should ignore on deploy
└── .gitignore
```

## Quick start (no Salesforce org needed)

```bash
npm install
npm run lint
npm run test:unit
```

Then follow **docs/PIPELINE_GUIDE.md** to push to GitHub and watch the pipeline run.
