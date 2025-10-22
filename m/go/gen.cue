@experiment(aliasv2)
@experiment(explicitopen)

package zoo

#Food: {
    name: string
    cost: float
}

#Dog: {
    age: int
    age: >= 0
    name: string
    snack: #Food
}