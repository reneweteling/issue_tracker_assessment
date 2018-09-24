# Issue tracker v2

## Overview

The idea behind the task is to implement an issue tracker like JIRA, Zendesk, or Trello. It should be very simple with only few features.

The goal is to show working example. Precise implementation of a particular feature is not that important as long as you can explain difficulties you face or a better approach.

The following description doesn’t cover all the details, so you are free to make decisions about the features on your own. 

Also please ask questions if something is not clear. Any questions are welcome. My email is kostya@studytube.nl.

## Description

**The application should implement only REST API**

As a regular user you should:
- [x] be able to log into the system
- [x] be able to create/update/delete **only your** issues
- [x] see the list of **only your** issues (most recent at the top)
- [x] **not** be able to update the status of your issues
- [x] **not** be able to update the assignend manager of your issues

As a manager you should:
- [x] be able to log into the system
- [x] be able to see the list of **all** issues
- [x] be able to assign an issue to only **yourself** and only if it is **not already assigned** to somebody else
- [x] be able to unassign an issue from **yourself**
- [x] be able to change the status of the issue **only** if the issue is assigned to you
- [x] **not** be able to assign an issue to somebody else
- [x] **not** be able to change the status of an issue **unless** it is assigned to you

### Notes
- [x] issue statuses: “pending”, “in progress”, “resolved”. Default: “pending”
- [x] if the issue has “in progress”, or “resolved” status the assignee is required. It can’t be unassigned in these two statuses
- [x] users and managers should be able to filter by “status”
- [x] pagination should be implemented, 25 issues in the response.
- [x] if you use JSON, please make sure the error responses for 500, 400, 422, etc, are also in JSON format
- [x] please describe how to login into your application and how to authorize API calls

# Assignment notes
It took me about 3,5 to 4 hours to get this project done. Its a fun example app. Not to difficult and it has allot of disiplines.
I would like to point out that i took some gems to speed up the process. For a production environment, sqlite, jbuiler would never be used
postgres, redis, elasticsearch for the data retreival and fast_jsonapi for the json conversion. Depending on the acl roles maybe something other than
cancancan and if we would add an user interface to this api knock would probably traded in for devise. But hey... its an assignment.

I hope its to your liking!

All the best,

![René Weteling](http://www.weteling.com/zzz/footer.png)

I love open source software!
See [my other projects][blog]
or [hire me][hire] to help build your product.

  [blog]: http://www.weteling.com/
  [hire]: http://www.weteling.com/contact/


## Running locally

Make sure you have ruby 2.5.1 installed, if not you could do so by:
```
rbenv install 2.5.1
```
Then:
```
git clone git@github.com:reneweteling/issue_tracker_assessment.git
cd issue_tracker_assessment
./bin/setup
```

### Logging in to the system & authenticating calls
See db/seeds.rb
To authenticate all calls, a bearer token needs to be present. To receive the token execute the call below to login:
```
curl -X POST \
  http://localhost:3000/api/v1/user_token \
  -H 'Content-Type: application/json' \
  -d '{
	"auth":{
		"email": "dwight@dm.com",
		"password": "test123"
	}
}'
```

This wil return a JWT token, use this token as Bearer token described below:
```
curl -X GET \
  http://localhost:3000/api/v1/issues \
  -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1Mzc4NjM2MjMsInN1YiI6Mn0.pvztEtbGOFttDUJwYUMDlF4BMij5M5Skrkkjdy2oqNY'
```

### available routes:
```
                   Prefix Verb   URI Pattern                                                                              Controller#Action
            api_v1_issues GET    /api/v1/issues(.:format)                                                                 api/v1/issues#index {:format=>:json}
                          POST   /api/v1/issues(.:format)                                                                 api/v1/issues#create {:format=>:json}
             api_v1_issue GET    /api/v1/issues/:id(.:format)                                                             api/v1/issues#show {:format=>:json}
                          PATCH  /api/v1/issues/:id(.:format)                                                             api/v1/issues#update {:format=>:json}
                          PUT    /api/v1/issues/:id(.:format)                                                             api/v1/issues#update {:format=>:json}
                          DELETE /api/v1/issues/:id(.:format)                                                             api/v1/issues#destroy {:format=>:json}
        api_v1_user_token POST   /api/v1/user_token(.:format)                                                             api/v1/user_token#create {:format=>:json}
```
The api_v1_issues index page also accepts the querystring `page` for pagination and `status` (CSV) for the status filter.
For a detailed working of the app, please read through the specs.