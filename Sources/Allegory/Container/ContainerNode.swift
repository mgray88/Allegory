//
// Created by Mike on 7/29/21.
//

public protocol ContainerNode: AnyObject {
    func replaceSubnodes(_ block: () -> Void)
}
