# ci-scanning

Security Mountaineering, Dec. 4th lesson. 

We'll be exploring dependency management, vulnerability scanning, and CI integration this week. 


## Teams: 
securitymountaineeringteam1@dolpheus.com
     ...  team 2, 3, 4. 4 teams total.

Password will be disclosed at the time of training. Who stores those on GitHub anyway?! ;) 

## URL needed: 

dolpheus.jfrog.io

# Overview of the Lesson and Lab

Situation: 
You're a developer that wants to create an app that users can download and run to get their public IP. Because you care about security and availability, you want to make sure that you get this delivered in a way that's most likely to be free of errors and contain minimal vulnerabilities. 

Tasks: 
* log into my Artifactory instance, then view & set up reports as needed in X-Ray (a dependency and vulnerability scanning tool)
* Log into your github and create some reusable secrets for authenticating to jFrog
* Create a new repo & actions workflow to automatically test, build, and publish a python-based dockerized app
* Remediate vulnerabilities in the container image
* validate that your container image passes linting tests and vulnerability scans

Things not covered here:
* in-pipeline testing with automatic failing: I didn't have time for this one, and our Twistlock setup isn't good for us to hit with these non-real things
* integration/unit testing -- consider working that in from Michael's training courses! 
* other languages, but you should totally consider re-working this for golang (go fmt will serve like black)
* hard dependency management -- this one is super straightforward due to time constraints. Consider some of our multi-GB maven/gradle builds!

## Steps: 

1. Open your GitHub account and create a new repository for today's lesson. 

2. Go to the Secrets page, and create 2 new secrets: 

`REGISTRY_USERNAME = <username listed above for your team>`

`REGISTRY_PASSWORD = <Password that I'll give out just in time during the class>`

3. the next step is a shortcut to what you would see doing this locally. I'd recommend those with docker installed run these: 
According to the repository permission, you will need to login to your repository with docker login command

`docker login dolpheus.jfrog.io`

Pull an image.

`docker pull hello-world`

Tag an image. Substitute your team number for this if needed. 

`docker tag hello-world dolpheus.jfrog.io/docker-test-repo/hello-world:team1`

Then push it to your repository.

`docker push dolpheus.jfrog.io/docker-test-repo/hello-world:team1`


4. Fork my code: https://github.com/DolpheusLabs/ci-scanning
---->> it's in the upper right, just under your user picture

4a. Go ahead and go to the actions pane to kick off a build if it didn't already.

5. Let's look at the files here one by one. 
* we have a .gitignore file, which is used to prevent certain things from ending up in Git. It's set for some python defaults, but I've not changed it. 
* We have the Dockerfile, and if we open that up we can see a pretty straightforward setup. Some of you may notice some things that we might be looking at later on in this file. We'll come back to that in a moment. 
* Our License file - good for open source projects! I've selected MIT, but that's another discussion for another day. 
* Readme - that's this! 
* main.py, and if we open that we see it's *really* straightforward. 
* requirements.txt, which is pretty simple looking and just has some packages that we've got installed. 

6. Before we get going too much, let's go see what happens if we have this project pushed up to Artifactory, so please go ahead and log in there. I'll do the same here. 
* If we look in the artifacts, we can see this little project. Clicking into the docker info we can also see each layer and the tag applied. 
* I've gone ahead and created some watches and reports for us to get going (artifactory isn't what I'm meant to be teaching today). **What do you think we will find when we open up these vulnerability reports (severity, quantity, etc)? Why?**

...
<reviewing the findings in xRay>
...

7. What's the first thing we might want to try to do for making these vulns go away? 
* some may say upgrade the base image. That might have problems with the stuff on top, no?
* some may say to upgrade package by package as needed. That would take forever and may not get the base image patched, no? 
* some may say to edit requests.txt. That may not get everything either, no? 

These are really all right answers, and I've made sure that our friendly app here will work a lot more often than some of the complicated stuff we see here at work. Let's start with the base image -- after all, Python 2.7 went EOL in January 2020 -- that's nearly a year ago!

8. Go ahead and edit the dockerfile from python 2.7 to a more recent one. https://hub.docker.com/_/python?tab=tags
* Should you use python:latest? 
* Should you use python 3.8.1 like we currently see a lot of? 
* Should you use python 3.9.0 even though it's only about 12 hours old?

Personally, I'd recommend the latter. The Python delivery testing is quite thorough, and minor versions don't tend to upset the apple cart -- especially for an app as simple as ours. I don't like defaulting to one version you just see a lot -- to me that gets people trending towards something old and comfortable rather than building evolutionary architectures that are ready to receive updates. Arbitrarily choosing 3.8.1 because we see it a lot is a fast path to being stuck on 2.7 or 2.6.5 as so many folks are today. 

To be clear, I do NOT recommend the :latest tag. This is great for personal projects and/or companies with VERY rigorous test automation (integration, unit, smoke, vuln, etc.) because using this is a fast way to lose easy semantic versioning. I would argue it's much better to version your images and apps so that you could at any point recreate exactly what was built. 

9. This should kick off a github actions build. If not, you may need to enable that. If you've been successful, it'll take a couple minutes and will build, tag, and push the container image to jFrog. 
* review the steps in the workflow file, monitor the progress in the Actions pane, and refresh jFrog once complete. 

10. Take a look at the images report. Still a lot of vulns! We can even remove your previous image, but it should still show some vulns. 

11. Let's filter that report on jinja. 

12. Notice that there's some big vulns there. We didn't get that from the base image though; we got that from the requirements.txt file. At some point, a developer thought they needed that (or, perhaps more likely: they copy/pasted or re-used a repo and didn't clean it up! That's *increcibly* common). But, we can see some kinda cool things here: 
* Because there's a semantically versioned callout for jinja 2.9 here, we know that we can build exactly this image in the future.
* We could try to improve this vulnerability report by updating the version, or potentially even making it versionless. Another option would be to use the >= or some of the fancy operators to get the version in a range. 
* another option.... Jijna is a web template engine for Django; Django is a webapp framework using a model-template-view architecture. Do you see any references to that in the main.py? Here's how you'd know - an example showing the import statement from the top of the file and something using the template engine.

>>> from jinja2 import Template
>>> template = Template('Hello {{ name }}!')
>>> template.render(name='John Doe')
u'Hello John Doe!'


**so... we can probably remove this. Let's comment out that line and add a note as to why so that if something breaks we can put it back**

13. We may need to again remove some older images, or perhaps tune the report to look at just the newest things, but the vulns should be looking lots better. 

14. Has anyone tried pulling this app locally or building locally? Did anyone get it to work? 

... 

probably not, let's go ahead and do that now to see the errors.

`docker run -it dolpheus.jfrog.io/docker-test-repo/public-ip-printer:<YOUR LATEST TAG HERE> /bin/sh`

15. Let's try running the program: 
`python main.py`

Should fail. Good news though, if you were on the 2.7 image there wasn't tab complete, so you did yourself a favor by updating first. Anyway, looks like this dependency isn't met, and that's because requests isn't a pre-installed module with Python; it must be installed separately. Let's test that then get that fixed in the image. 

`python -m pip install requests`

`python main.py`

Yay! New error!!! Now let's abstract that to the list of pacakages, even if there's only 1. This will keep the dockerfile from growing in layers count and will make it much more simple to maintain over time (think: it's 3:00 AM, 18 months from now. Will you remember? Yeah, no. That's why we use the requirements.txt file). 

Uncomment that line in the Dockerfile to get this change in, and let it build. 

16. Pull the new image down and validate. This time you should still get an error when trying to run the python command, but everything else should be working (vulns, dependencies). 

17. At this point I want to focus on Black for a moment. Golang has go fmt; sentinel has sentinel fmt, python has Black. It's a way to canonically format your code, and should help you save time with linting. You can, **and should** use linting tools such as pylint and flake8 in your development process and deployment pipeline; black is a way to help get some of the silly stuff sorted for you automatically. Personally I'd recommend this order: black -> pylint -> flake8, as that's easiest -> hardest and helps sort out things that computers can first then saves your brain cycles for only what the computer can't do. 

Your python file has some extraneous spaces. Sure, you could delete those, but we want to ensure that all python files are automatically formatted for the best success in development and testing. This is a key part in making the cool robust testing that lets you use chaos monkey and similar! 

Go to the workflow file, and uncomment the lines for Black per the instructions there. Go ahead and commit the code, and watch the result! 

18. Validate that your code formats, builds, publishes, tags, and is able to be successfully downloaded & run with the below: 
`docker run dolpheus.jfrog.io/docker-test-repo/public-ip-printer:<YOUR LATEST TAG HERE>`
^ note: there's no interactive tty (-it) and no shell (/bin/sh) here. It should download and run automatically.



