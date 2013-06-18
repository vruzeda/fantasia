Object::_injectDependency = (Class) ->
  @_injectedDependencies ?= []
  @_injectedDependencies.push Class

Object::_injectDependencies = (Classes...) ->
  @_injectedDependencies ?= []
  @_injectedDependencies.push Class for Class in Classes


class DependencyInjector

  @requireInstance: (Class) ->
    injectedDependencies = Class._injectedDependencies

    dependencyInstances = []
    dependencyInstances.push @requireInstance dependency for dependency in injectedDependencies if injectedDependencies?

    new Class dependencyInstances...


module.exports = DependencyInjector