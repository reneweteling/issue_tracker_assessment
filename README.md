# Issue tracker v2

## Overview

The idea behind the task is to implement an issue tracker like JIRA, Zendesk, or Trello. It should be very simple with only few features.

The goal is to show working example. Precise implementation of a particular feature is not that important as long as you can explain difficulties you face or a better approach.

The following description doesn’t cover all the details, so you are free to make decisions about the features on your own. 

Also please ask questions if something is not clear. Any questions are welcome. My email is kostya@studytube.nl.

## Description

**The application should implement only REST API**

As a regular user you should:
- be able to log into the system
- be able to create/update/delete **only your** issues
- see the list of **only your** issues (most recent at the top)
- **not** be able to update the status of your issues
- **not** be able to update the assignend manager of your issues

As a manager you should:
- be able to log into the system
- be able to see the list of **all** issues
- be able to assign an issue to only **yourself** and only if it is **not already assigned** to somebody else
- be able to unassign an issue from **yourself**
- be able to change the status of the issue **only** if the issue is assigned to you
- **not** be able to assign an issue to somebody else
- **not** be able to change the status of an issue **unless** it is assigned to you

### Notes
- issue statuses: “pending”, “in progress”, “resolved”. Default: “pending”
- if the issue has “in progress”, or “resolved” status the assignee is required. It can’t be unassigned in these two statuses
- users and managers should be able to filter by “status”
- pagination should be implemented, 25 issues in the response.
- if you use JSON, please make sure the error responses for 500, 400, 422, etc, are also in JSON format
- please describe how to login into your application and how to authorize API calls 

## Running locally

`bin/setup` shoud contain all required steps to run the application locally. Example:

```
git clone git@github.com:organization/app.git
cd app
./bin/setup
```