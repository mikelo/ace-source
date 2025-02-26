# Project Readme

## Overview

This project leverages Docker to build and deploy an IBM App Connect Enterprise (ACE) application sourced from a GitHub repository. The Containerfile provided outlines the steps to create a Docker image that packages and deploys an ACE application.

## Containerfile Breakdown

### Base Images

1. **Source Code Fetching**:
    - `FROM docker.io/alpine/git as git`: Uses the Alpine Git image to clone the source code repository.
    - `WORKDIR /tmp`: Sets the working directory to `/tmp`.
    - `RUN git clone https://github.com/mikelo/ace-source`: Clones the repository containing the ACE application source code.

2. **ACE Environment Setup**:
    - `FROM cp.icr.io/cp/appc/ace:13.0.2.0-r1 AS ace`: Uses the IBM ACE image as the base image for the final build.
    - `ENV LICENSE=accept`: Accepts the IBM license agreement.
    - `ENV DATA=/tmp/data`: Sets the data directory environment variable.
    - `ENV SKIP=""`: Sets an environment variable used for custom purposes.
    - `COPY --from=git --chown=aceuser:mqbrkrs /tmp/ace-source/ /tmp/`: Copies the cloned source code from the `git` stage to the `/tmp/` directory in the `ace` stage, changing the ownership to `aceuser:mqbrkrs`.
    - `WORKDIR /tmp/`: Sets the working directory to `/tmp/`.

3. **Application Packaging and Deployment**:
    - `ENV MQSI_JARPATH=$MQSI_JARPATH:/tmp/ACME_CoffeeRoasters_Java`: Updates the `MQSI_JARPATH` environment variable to include the Java project path.
    - `RUN . /opt/ibm/ace-13/server/bin/mqsiprofile && ibmint package --input-path . --output-bar-file coffee.bar --project ACME_CoffeeRoasters_Application --project ACME_CoffeeRoasters_Java --project ACME_CoffeeRoasters_UnitTest --project ACME_CoffeeRoasters_ComponentTest && mqsicreateworkdir /tmp/work-dir && ibmint deploy --input-bar-file coffee.bar --output-work-directory /tmp/work-dir`: 
        - Sources the ACE profile.
        - Packages the ACE projects into a BAR file named `coffee.bar`.
        - Creates an ACE work directory.
        - Deploys the BAR file to the work directory.
    - `ADD entrypoint.sh .`: Adds the `entrypoint.sh` script to the image.
    - `EXPOSE 7600`: Exposes port 7600.
    - `EXPOSE 7800`: Exposes port 7800.
    - `ENTRYPOINT [ "/tmp/entrypoint.sh" ]`: Sets the entrypoint to the `entrypoint.sh` script.

## Getting Started

### Prerequisites

- Podman installed on your local machine.
- Internet access to pull the Docker base images and clone the GitHub repository.

### Building the Docker Image

1. Clone the project repository:
    ```sh
    git clone https://github.com/mikelo/ace-source
    cd ace-source
    ```

2. Build the Docker image:
    ```sh
    podman build -t ace-app .
    ```

### Running the Docker Container

1. Start a container from the image:
    ```sh
    podman run -d -p 7600:7600 -p 7800:7800 ace-app
    ```

### Notes

- The `entrypoint.sh` script is expected to be part of the project repository and should handle the startup logic for the ACE application.
- Modify the `Containerfile` and `entrypoint.sh` as needed to fit the specific requirements and configurations of your ACE application.

## License

By using this Containerfile and associated scripts, you agree to the terms and conditions of the IBM license agreement.

## Contributing

Feel free to submit issues and enhancement requests. Contributions are welcome!

## Author

- Michele (https://github.com/mikelo)

For more information, please refer to the official IBM ACE documentation.

---

This README file provides a comprehensive overview of the Docker-based setup and deployment process for the ACE application. Adjust the content as necessary to fit the specific details and requirements of your project.