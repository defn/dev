#Input: {
    terraform: #Terraform
	dog: #Dog
    cat: #Cat
}

#Terraform: {
    organization: string
    workspace: string
}

#Dog: {
    name: string | *"dog"
}

#Cat: {
    name: string | *"cat"
}

input: #Input
