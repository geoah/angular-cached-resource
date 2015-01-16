module.exports = (providerParams) ->
  {$log} = providerParams
  ResourceCacheEntry = require('./resource_cache_entry')(providerParams)

  class ResourceCacheArrayEntry extends ResourceCacheEntry
    defaultValue: []
    cacheKeyPrefix: -> "#{@key}/array"

    addInstances: (instances, dirty) ->
      cacheArrayReferences = []
      for instance, index in instances
        cacheInstanceParams = instance.$params()
        if Object.keys(cacheInstanceParams).length is 0
          if providerParams.forceParam?.force? isnt true
            $log.error """
              instance #{instance} doesn't have any boundParams. Please, make sure you specified them in your resource's initialization, f.e. `{id: "@id"}`, or it won't be cached. You can force caching for such resources with `$cachedResourceProvider.forceParam` setting.
            """
          else if providerParams.forceParam?.key? and providerParams.forceParam?.prefix?
            cacheInstanceParams["providerParams.forceParam.key"] = "#{providerParams.forceParam.prefix}-#{index}"
            if providerParams.forceParam?.silenceWarning isnt true
              $log.error """
              instance #{instance} doesn't have any boundParams and has been forced to cache by the `$cachedResourceProvider.forceParam` setting.
              """
          else
            $log.error """
              instance #{instance} doesn't have any boundParams and `forceParam` setting is missing a key or prefix. Please add them for this to work.
            """
        cacheArrayReferences.push cacheInstanceParams
        cacheInstanceEntry = new ResourceCacheEntry(@key, cacheInstanceParams).load()
        cacheInstanceEntry.set instance, dirty
      @set cacheArrayReferences, dirty
