# Do Continuous Integration Yourself

‘Nuff said.

## Philosopy

If you can run your tests for a project locally, then you should be able to run CI locally too.
DCIY does exactly this. There is no system for multiple users, or for managing SSH keypairs,
or anything else—all DCIY does is provide a web interface for checking out Git repositories
and running CI on them, all as the same user (you) that is firing up the DCIY server.

## Hacking on DCIY

Run these commands to get set up for hacking on this locally:

```sh
git clone https://github.com/cobyism/dciy
cd dciy
script/server
```

The [`script/server`](./script/server) command should do all the bootstrapping and
process starting necessary, and should give you a DCIY server running locally on
at the following address: [`http://localhost:6161`](http://localhost:6161).

## Adding a project

Go to [the root URL](http://localhost:6161/) or [`/projects`](http://localhost:6161/projects)
and click "New Project", and type in the `<owner>/<repo>` part of your GitHub project
(leave off the `https://github.com` and the `.git` parts). Submitting the form will
give you a new project which you can run builds for.

## Triggering a Build

Go to [`/builds`](http://localhost:6161/builds) and click "New Build". Enter the
branch name or commit SHA that you want to build the project at, and submit the form.
DCIY will then go off and do the following:

- `cd` into a workspace directory for that project, or clone it down if it hasn’t seen it before.
- Run a `git fetch` to make sure it has everything locally it needs.
- Checks out the project at the specified branch or commit.
- Initiates and prepares submodules, if there are any.
- Executes `script/cibuild` which should contain the commands to run the project’s test suite.

Keeping an eye on [`/builds`](http://localhost:6161/builds) will show you the status of the build
as it runs in the background, and you can click on the build to view the output once it’s finished.

## License

[MIT](./LICENSE).
