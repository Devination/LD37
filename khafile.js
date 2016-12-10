let project = new Project('LD37');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('nape');
project.addParameter('-dce full');
resolve(project);
