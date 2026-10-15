# my-web: nginx in a custom Docker image

A simple demo project: an nginx web server serving a custom page, built from a Dockerfile.

## What it shows
- Writing a Dockerfile (`FROM`, `COPY`)
- Building and tagging images (`my-web:1`, `my-web:2`, `my-web:3`)
- Running a container with port mapping
- Releasing a new version and rolling back to an earlier one
- Keeping the build context small with `.dockerignore`

## Files
| File | Purpose |
|---|---|
| `Dockerfile` | Starts from the official nginx image and copies in my page |
| `index.html` | The page nginx serves |
| `.dockerignore` | Files left out of the build context |

## Run it
```
docker build -t my-web:1 .
docker run -d --name myweb -p 8081:80 --rm my-web:1
```
Open http://localhost:8081. Stop it with `docker stop myweb` (`--rm` removes the container).

## Release and rollback
1. Edit `index.html`.
2. Build a new tag: `docker build -t my-web:2 .`
3. Swap: `docker stop myweb`, then run the same command with `my-web:2`.
4. Roll back by running the previous tag. The old image is still there.

## Key points
- An image is a sealed snapshot: editing a file doesn't change a running container. You rebuild and replace it.
- The `.` in `docker build` is the build context: the folder sent to the builder.
- Build the new image before stopping the old container, so the site stays up if the build fails.
