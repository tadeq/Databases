from pymongo import MongoClient
import pprint
from bson.code import Code

if __name__ == "__main__":
    client = MongoClient('localhost', 27017)
    jeopardy = client.Jeopardy
    questions = jeopardy.questions
    query1 = questions.find({"air_date": {"$gte": "2012-01-01"}, "round": "Jeopardy!"}, {"show_number": 0}).sort(
        [("show_number", -1)])
    query2 = questions.count({"air_date": {"$gte": "2012-01-01"}, "round": "Jeopardy!"})
    for q in query1:
        pprint.pprint(q)
    print(query2)
    pipeline = [
        {"$match": {"show_number": {"$lt": "2500"}}},
        {"$group": {"_id": "$category", "total": {"$sum": 1}}},
        {"$sort": {"total": -1}}
    ]
    query3 = questions.aggregate(pipeline)
    for q in query3:
        pprint.pprint(q)
    mapper = Code("""
                    function() {
                        if (this.category)
                        emit(this.category, new NumberInt(((new String(this.value)).substring(1))));
                    }
                   """)
    reducer = Code("""
                    function(category, values){
                        var sum = Array.sum(values);
                        return sum/values.length
                    }
                    """)
    result = questions.map_reduce(mapper, reducer, "results")
    for res in result.find():
        pprint.pprint(res)
