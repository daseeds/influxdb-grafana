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
        value = j["fields"][field]
        if type(value) == "bool":
            metric.fields[field] = bool(value)
        elif type(value) == "string":
            metric.fields[field] = str(value)
        elif type(value) == "int":
            if "time" in field.lower():
                # we convert only keys with time in its name to int:
                metric.fields[field] = int(value)
            else:
                # all other keys are treated as float:
                metric.fields[field] = float(value)
        elif type(value) == "float":
            metric.fields[field] = float(value)
    
    for tag in j["tags"].keys():
        metric.tags[tag] = j["tags"][tag]
    metric.name = j["name"]
    metric.time = j["timestamp"]

    return metric