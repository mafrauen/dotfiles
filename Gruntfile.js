/* jshint node:true */
var
  glob = require('glob'),
  path = require('path'),
  fs = require('fs'),
  colors = require('cli-color'),
  RSVP = require('rsvp');

function getGlob(pattern) {
  return new RSVP.Promise(function (resolve, reject) {
    glob(pattern, function (err, files) {
      if (err) return reject(err);
      resolve(files);
    });
  });
}

function handleFs(p, resolve, reject) {
  return function(err) {
    if (err && err.errno !== -17) {
      return reject(err);
    }

    if (err) {
      console.log(colors.blue(p));
    } else {
      console.log(colors.green.bold(p));
    }

    resolve();
  };
}

function mkdir(dir) {
  return new RSVP.Promise(function (resolve, reject) {
    fs.mkdir(dir, handleFs(dir, resolve, reject));
  });
}

function makeLink(src, dest) {
  src = path.join(process.cwd(), src);
  return new RSVP.Promise(function (resolve, reject) {
    fs.symlink(src, dest, handleFs(dest, resolve, reject));
  });
}


var home = process.env.HOME;

function symlinks() {
  var done = this.async();
  function link(file) {
    var
      name = '.' + path.basename(file, '.symlink'),
      dest = path.join(home, name);
    return makeLink(file, dest);
  }

  getGlob('**/*.symlink').then(function (files) {
    return RSVP.all(files.map(link));
  }).then(done);
}

function snippets() {
  var done = this.async();
  function link(file) {
    var dest = path.join(home, '.vim', file);
    return makeLink(file, dest);
  }

  mkdir(path.join(home, '.vim', 'snippets')).then(function () {
    return getGlob('snippets/*');
  }).then(function (files) {
    return RSVP.all(files.map(link));
  }).then(done);
}

function prompts() {
  var done = this.async();
  function link(file) {
    var
      name = 'prompt_' + path.basename(file, '.zsh') + '_setup',
      dest = path.join(home, '.zprezto', 'modules', 'prompt', 'functions', name);
    return makeLink(file, dest);
  }

  getGlob('prompt/*').then(function (files) {
    return RSVP.all(files.map(link));
  }).then(done);
}

module.exports = function (grunt) {
  grunt.registerTask('symlinks', symlinks);
  grunt.registerTask('snippets', snippets);
  grunt.registerTask('prompts', prompts);

  grunt.registerTask('default', ['symlinks', 'snippets' ,'prompts']);
};
