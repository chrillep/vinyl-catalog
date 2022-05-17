# Vinyl Catalog

This repository is part of a series of posts that are going to be published in [www.thizaom.com](https://www.thizaom.com).
The main goal of this series is to enable the setup of a Golang Vinyl catalogs application running within a Kubernetes Cluster that interacts with a database.
This repository will be tagged for each part of the series (ie. Pt1 is tag 1.0.0, Pt2 is tag 2.0.0 and so on).

## Run Locally

Clone the project

```bash
  git clone git@github.com:thiduzz/vinyl-catalog.git
```

Go to the project directory

```bash
  cd vinyl-catalog
```

Start Golang server

```bash
  make start-goland-server
```

Start NextJS server

```bash
  make start-nextjs-server
```

Start both servers

```bash
  make start-servers -j
```

## Authors

- [@thiduzz](https://www.github.com/thiduzz)

## License

[MIT](https://choosealicense.com/licenses/mit/)
