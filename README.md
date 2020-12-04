# ci-scanning

Security Mountaineering, Dec. 4th lesson. 

We'll be exploring dependency management, vulnerability scanning, and CI integration this week. 


## Teams: 
securitymountaineeringteam1@dolpheus.com
     ...  team 2, 3, 4. 4 teams total.

Password will be disclosed at the time of training. Who stores those on GitHub anyway?! ;) 

# URL needed: 
dolpheus.jfrog.io

## Steps: 

According to the repository permission, you will need to login to your repository with docker login command
`docker login dolpheus.jfrog.io`

Pull an image.
`docker pull hello-world`

Tag an image.
`docker tag hello-world dolpheus.jfrog.io/docker-test-repo/hello-world`

Then push it to your repository.
`docker push dolpheus.jfrog.io/docker-test-repo/hello-world`
