import { Edge, Node, orderEdges } from './types';

export function constructEulerTour(node: Node, tour: number[] = []) {
    // visit the node
    tour.push(node.value);

    if (node.left) {
        constructEulerTour(node.left, tour);
        // visit the current node after visiting the left subtree
        tour.push(node.value);
    }
    if (node.right) {
        constructEulerTour(node.right, tour);
        // visit the current node after visiting the right subtree
        tour.push(node.value);
    }
}
