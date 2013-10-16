# Do Continuous Integration Yourself

DCIY lets you do continuous integration testing locally through a web interface.

### Screenshots

![All builds](https://f.cloud.github.com/assets/296432/1341069/bfd8aec0-3641-11e3-81fb-663f6a181a07.png)

![Build output](https://f.cloud.github.com/assets/296432/1341077/f177b20a-3641-11e3-967b-f2dcdedc7fc9.png)

## Why DCIY?

If you can run your tests for a project locally in the terminal, then you should
be able to run CI with a web interface and keep track of build output locally too.
DCIY does exactly this. There is no system for multiple users, or for managing SSH keypairs,
or anything else—all DCIY does is provide a web interface for checking out Git repositories
and running CI on them, all as the same user (you) that is firing up the DCIY server.

### Alternatives that might suit you better

I started this project because I wanted to run CI on some other private
side-projects I’m working on, and couldn’t find anything else lightweight
enough that suited my needs. It is not intended to be a a fully-fledged,
production-ready CI environment, so if you want something more that’s also free,
you should check out some of the following projects:

- [Travis CI](https://travis-ci.org/) - If your project is public, this is probably your best option.
- [Strider CD](http://stridercd.com/) - An open source continuous integration & deployment server written in Node.js.
- [Kochiku](https://github.com/square/kochiku) (by [Square](https://squareup.com/)) - An open source distributed testing platform.
- [Jenkins CI](http://jenkins-ci.org/) - Might be ugly, but it’s open source, widely used, and has a large following.

### A note about security

DCIY runs all commands on your behalf, so it’s probably not a good idea to
use DCIY in situations where you’re concerned about security. It is your
responsibility to ensure that you trust the contents of the branches you build,
and that you shut down the DCIY server when you’re not using it.

I’d love to find ways of making this less of an issue in the future, such as
providing a way to easily sandbox the build process (using some combination of
technologies like Vagrant and Docker, maybe?), but even if that happens, it’s
still important to be aware of what code you’re running on your machine.

## Getting DCIY running

Run these commands from your terminal to get set up for hacking on this locally:

```sh
git clone https://github.com/cobyism/dciy
cd dciy
script/server
```

The [`script/server`](./script/server) command should do all the bootstrapping and
process starting necessary, and should give you a DCIY server running locally on
at the following address: [`http://localhost:6161`](http://localhost:6161).

## Using DCIY

### Adding a project

Go to [the root URL](http://localhost:6161/) or [`/projects`](http://localhost:6161/projects)
and click "New Project", and type in the `<owner>/<repo>` part of your GitHub project
(leave off the `https://github.com` and the `.git` parts). Submitting the form will
give you a new project which you can run builds for.

### Triggering a Build

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

## Contributing to DCIY

I’d :heart: to receive contributions and feedback from anyone,
and there’s more ways to do that than writing code.

### Contributing code

1. Fork the repository.
2. Create a branch (e.g. `my-awesome-feature`) for the work you’re going to do.
3. Make your awesome changes in your topic branch.
4. Send a pull request from your branch to this repository.

### Other ways to contribute

- Try the project out yourself.
- [File issues](https://github.com/cobyism/dciy/issues/new) about bugs, problems, or inconsistencies you run into.
- [File issues](https://github.com/cobyism/dciy/issues/new) with suggestions, feature ideas, or UI mockups for improvements.
- Read through the documentation (just this `README` for now), and look for ways it could be improved. Click "Edit" on the file and make the changes yourself if you can!

## License

[MIT](./LICENSE).
