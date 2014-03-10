/* jshint node:true */
var
  glob = require('glob'),
  path = require('path'),
  fs = require('fs'),
  colors = require('cli-color'),
  RSVP = require('rsvp');

// File actions

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

function symlink(src, dest) {
    src = path.join(process.cwd(), src);
    return new RSVP.Promise(function (resolve, reject) {
      fs.symlink(src, dest, handleFs(dest, resolve, reject));
    });
}

function makeLink(getDest) {
  return function (file) {
    return symlink(file, getDest(file));
  };
}

// Tasks

var home = process.env.HOME;

function symlinks() {
  var done = this.async();
  getGlob('**/*.symlink').then(function (files) {
    return RSVP.all(files.map(makeLink(function (file) {
      var name = '.' + path.basename(file, '.symlink');
      return path.join(home, name);
    })));
  }).then(done);
}

function snippets() {
  var done = this.async();
  mkdir(path.join(home, '.vim', 'snippets')).then(function () {
    return getGlob('snippets/*');
  }).then(function (files) {
    return RSVP.all(files.map(makeLink(function (file) {
      return path.join(home, '.vim', file);
    })));
  }).then(done);
}

function prompts() {
  var done = this.async();
  getGlob('prompt/*').then(function (files) {
    return RSVP.all(files.map(makeLink(function (file) {
      var name = 'prompt_' + path.basename(file, '.zsh') + '_setup';
      return path.join(home, '.zprezto', 'modules', 'prompt', 'functions', name);
    })));
  }).then(done);
}

// Config

module.exports = function (grunt) {
  grunt.registerTask('symlinks', symlinks);
  grunt.registerTask('snippets', snippets);
  grunt.registerTask('prompts', prompts);

  grunt.registerTask('default', ['symlinks', 'snippets' ,'prompts']);
};
