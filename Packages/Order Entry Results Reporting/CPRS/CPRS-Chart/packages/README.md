# Code Project Template

This repository is a template for code projects at VA.

While this template doesn't contain code -- that's for you to add -- it does have the issue templates and standard folder structure you will need for agile project management at VA. 

Take this template, and add your code. Also add documentaion for configuration management and deployment of your code, including:

- build and deploy instructions
- information on automated tests, and where to find results 
- instructions for how to set up local development

Document this here in your `README.md`, or in individual markdown files in the `docs` folder.

After you create your product's documentation repository from this template, please update the Team and Code sections below to link to the appropriate people and code.

Replace these introductory paragraphs with a description of your product. 

For an example that includes code, releases and issues in progress, see our demo Reading Time web application: https://github.com/department-of-veterans-affairs/reading-time-demo


## Product

- Product Name:
- Product Line Portfolio:

### Team Contacts

- Maintained by: @department-of-veterans-affairs/configuration-management
- Project Manager:
- Technical Team Lead:
- Configuration Manager:




## Code Description



### Deployment


#### Branching strategy

**UPDATE THIS FOR YOUR PROJECT AND BUILD STRATEGY**

Certain branches are special, and would ordinarily be deployed to various test environments:

- master: our default branch, for production-ready code. Master is always deployable. In our case, however, deployment does not happen automatically.
- pre-prod: code destined for the pre-production test server. This code might be deployed by hand or automatically, depending on the project and availability of a CI/CD solution.
- test: code that would probably autotmatically be pushed to a test or staging server. Again, in our case we don't do this -- but test deployment tasks like this are ideally automated with a CI/CD solution like Jenkins.

New code should be produced on a feature branch [following GitHub flow](https://guides.github.com/introduction/flow/). Most often, you'll want to branch from **master**, since that's the latest in production. File a pull request to merge into **test**, which can be deployed to our testing environment.



### Testing




### Installing




### License

See the [LICENSE](LICENSE.md) file for license rights and limitations.
