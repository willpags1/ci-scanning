# ci-scanning

Security Mountaineering, Dec. 4th lesson. 

We'll be exploring dependency management, vulnerability scanning, and CI integration this week. 


## Teams: 
securitymountaineeringteam1@dolpheus.com
     ...  team 2, 3, 4. 4 teams total.

Password will be disclosed at the time of training. Who stores those on GitHub anyway?! ;) 

## URL needed: 

dolpheus.jfrog.io

## Steps: 

1. Open your GitHub account and create a new repository for today's lesson. 

2. Go to the Secrets page, and create 2 new secrets: 

`REGISTRY_USERNAME = <username listed above for your team>`

`REGISTRY_PASSWORD = <Password that I'll give out just in time during the class>`

3. Go to GitHub Actions and create a new sample action. Enter the below:

  - uses: actions/checkout@v2   <-------------------- this should be what's already on line 26. 
      - name: Login to DockerHub Registry
        run: docker login -u ${{ secrets.REGISTRY_USERNAME }} -p ${{ secrets.REGISTRY_PASSWORD }} dolpheus.jfrog.io

According to the repository permission, you will need to login to your repository with docker login command

`docker login dolpheus.jfrog.io`

Pull an image.

`docker pull hello-world`

Tag an image.

`docker tag hello-world dolpheus.jfrog.io/docker-test-repo/hello-world`

Then push it to your repository.

`docker push dolpheus.jfrog.io/docker-test-repo/hello-world`
