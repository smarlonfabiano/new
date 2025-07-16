# Getting Started

This guide will help you get started with the project.

## Prerequisites

- Node.js (version 14 or higher)
- npm (version 6 or higher)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/smarlonfabiano/new.git
   cd new
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

## Development

### Code Style

This project uses ESLint and Prettier to enforce code style. You can run the linter with:

```bash
npm run lint
```

To automatically fix linting issues:

```bash
npm run lint:fix
```

To format code with Prettier:

```bash
npm run format
```

### Testing

Run tests with:

```bash
npm test
```

### Using Docker

You can also use Docker for development:

```bash
# Build and start the container
docker-compose up

# Run commands inside the container
docker-compose exec app npm test
```

## Project Structure

- `src/`: Source code
  - `index.js`: Main entry point
  - `utils/`: Utility functions
- `tests/`: Test files
- `docs/`: Documentation
- `.github/`: GitHub-related files (workflows, templates)

## Contributing

Please see the [CONTRIBUTING.md](../CONTRIBUTING.md) file for details on how to contribute to this project.