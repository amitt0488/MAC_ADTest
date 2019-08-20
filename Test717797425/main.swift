/*
    <samplecode>
        <abstract>
            Command line tool main.
        </abstract>
    </samplecode>
 */

import Foundation
import OpenDirectory

class Main: NSObject, ODQueryDelegate {

    func run() throws {
        let session = ODSession()
        let node = try ODNode(session: session, type: ODNodeType(kODNodeTypeAuthentication))
        let query = try ODQuery(
            node: node,
            forRecordTypes: kODRecordTypeUsers,
            attribute: nil,
            matchType: ODMatchType(kODMatchAny),
            queryValues: nil,
            returnAttributes: [
                kODAttributeTypeRecordName,
                kODAttributeTypeEMailAddress//,
                //kODAttributeTypeGroup // change
            ],
            maximumResults: 0
        )
        query.delegate = self
        query.schedule(in: .current, forMode: RunLoop.Mode.default.rawValue)
        RunLoop.current.run()
    }

    func query(_ query: ODQuery, foundResults: [Any]?, error: Error?) {
        if let error = error {
            print("*** query failed, error: \(error)")
            exit(EXIT_FAILURE)
        }
        guard let foundResults = foundResults else {
            print("*** query done")
            exit(EXIT_SUCCESS)
        }
        let records = foundResults as! [ODRecord]
        print("*** \(records.count)")
        for record in records {
            /*
            let email: String
            if
                let emailsAny = try? record.values(forAttribute: kODAttributeTypeEMailAddress),
                let emails = emailsAny as? [String],
                let firstEmail = emails.first
            {
                email = firstEmail
            } else {
                email = "?"
            }
            */
            let guidAny = try? record.values(forAttribute: "dsAttrTypeStandard:GeneratedUID");
            print("*** GUID: \(guidAny?[0] ?? "-")");
            print("**** \(record.recordName ?? "-") / Groups:")
            
            let groupsAny = try? record.values(forAttribute: "memberOf");
            let groups = groupsAny as? [String];
            for currGroup in groups ?? [] {
                print("--- \(currGroup)");
            }
           
            
            //print("\(record.recordName ?? "-") / \(email)")
        }
    }
}

func mainThrowing() throws {
    try Main().run()
}

func main() {
    do {
        try mainThrowing()
    } catch {
        print(error)
    }
}

main()
exit(EXIT_SUCCESS)
