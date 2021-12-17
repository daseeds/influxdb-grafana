load("json.star", "json")
load("logging.star", "log")
 
def apply(metric):
    error = catch(lambda: parseStdMsg(metric))
    if error != None:
        # Some code to execute in case of an error
        metric.fields["error"] = error
        return metric    
    #metric = parseStdMsg(metric)
    return metric

def parseStdMsg(metric):
    j = json.decode(metric.fields.get("value"))
    metric.fields.pop('value')
    
    for field in j["fields"].keys():
        metric.fields[field] = j["fields"][field]
    
    for tag in j["tags"].keys():
        metric.tags[tag] = j["tags"][tag]
    metric.name = j["name"]
    metric.time = j["timestamp"]

    return metric