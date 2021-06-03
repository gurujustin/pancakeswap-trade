#Create an alias for the container built from the node:alpine base image
FROM node:15 as builder

#Setting the working directory inside the container to be the same name as our app on our local machine.
WORKDIR "/my-static-app"

#Copying our package.json file from our local machine to the working directory inside the docker container.
COPY package.json ./

#Installing the dependencies listed in our package.json file.
RUN yarn install

#Copying our project files from our local machine to the working directory in our container.
COPY . .

#Create the production build version of the  react app
RUN yarn build

#Create a new container from a linux base image that has the aws-cli installed
FROM amazon/aws-cli

#Using the alias defined for the first container, copy the contents of the build folder to this container
COPY --from=builder /my-static-app/build .

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]

