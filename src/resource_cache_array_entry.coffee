module.exports = (providerParams) ->
  {$log} = providerParams
  ResourceCacheEntry = require('./resource_cache_entry')(providerParams)

  class ResourceCacheArrayEntry extends ResourceCacheEntry
    defaultValue: []
    cacheKeyPrefix: -> "#{@key}/array"

    addInstances: (instances, dirty) ->
      cacheArrayReferences = []
      for instance in instances
        cacheInstanceParams = instance.$params()
        if Object.keys(cacheInstanceParams).length is 0
          cacheInstanceParams["_fc"] = "default"
        cacheArrayReferences.push cacheInstanceParams
        cacheInstanceEntry = new ResourceCacheEntry(@key, cacheInstanceParams).load()
        cacheInstanceEntry.set instance, dirty
      @set cacheArrayReferences, dirty
