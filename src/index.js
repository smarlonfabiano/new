/**
 * Main entry point for the application
 */

const { greet } = require('./utils/greeting');

/**
 * Main function that runs when the application starts
 */
function main() {
  console.log('Application started');
  console.log(greet('World'));
}

// Run the main function if this file is executed directly
if (require.main === module) {
  main();
}

module.exports = { main };