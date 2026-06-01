# Fyn SDK $VERSION

The automatically generated sdk based on the swagger documentation in the [api repository](https://github.com/fyn-jobboard/api).

## Installation

### Bun

```bash
bun add github:fyn-jobboard/sdk#$VERSION
```

### Npm

```bash
npm install github:fyn-jobboard/sdk#$VERSION
```

## Usage

### Retreive jobs

```ts
import { JobsApi } from "fyn-api-sdk";
console.log(process.env.FYN_JWT);

const jobs = new JobsApi(
  {
    apiKey: process.env.FYN_JWT,
  },
  // example host
  "https://api.fyn.com",
  fetch,
);

const allJobs = await jobs.jobsControllerFindAllV1(
  undefined,
  undefined,
  "Web developper",
);
console.log(allJobs);
```
