# Circleback Orb


[![CircleCI Build Status](https://circleci.com/gh/MutinyHQ/circleback-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/MutinyHQ/circleback-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/MutinyHQ/circleback.svg)](https://circleci.com/developer/orbs/orb/mutinhq/circleback)

This orb is a helper when orchestrating pipelines with the [circleback pattern](https://circleci.com/blog/pipeline-orchestration-circleback/). It has commands for triggering another CircleCI pipeline and checking the status of the triggered pipeline.

This is useful when multiple projects in separate repositories are interdependent, such as running an integration test pipeline.

---

## Resources

[CircleCI Orb Registry Page](https://circleci.com/developer/orbs/orb/mutinyhq/circleback) - The official registry page of this orb for all versions, executors, commands, and jobs described.

[CircleCI Orb Docs](https://circleci.com/docs/orb-intro/#section=configuration) - Docs for using, creating, and publishing CircleCI Orbs.

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info mutinyhq/circleback | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/MutinyHQ/circleback-orb/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.
