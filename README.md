# ibm_apm Cookbook

I am no longer working on this code as of 2019-11-15.  I have moved on to check_mk.
My Check_MK project is private for now.

## Scope

Todo: Identify the scope of what exactly this cookbook addresses. Are there any
edge cases associated with your cookbook tasks that were decided not to be
supported?

## Requirements

Todo: List any technical requirements for using this cookbook. Do you need to
install binaries from the network? Does the cookbook make other assumptions
about the environment for it to be used? Does the operating system need to have
any special configuration before using this cookbook (i.e. disable selinux)?
Also, tailor the subsections below:

### Platforms

- Redhat 7.x+

### Chef

- Chef 12

### Dependencies

- lvm
- limits
- selinux
- hostsfile

## Usage

Todo: This will be unique depending on how the cookbook is developed and the
tools it provides to configure nodes. Here's a simple example of using a
cookbook and it's recipe. You'll want to elaborate on your own steps and include
any necessary steps like setting required attributes.

Place a dependency on the `ibm_apm` cookbook in your cookbook's
`metadata.rb`.

```
depends 'ibm_apm'
```

Then, in a recipe:

```
include_recipe 'ibm_apm::fix_apm'
```

If your cookbook provides resources, be sure to include examples of how to use
those resources, in addition to the resources documentation section below.

## Attributes

* `default['ibm_apm']['my_attribute']`: Describe the purpose or usage of
  this attribute. Defaults to `somevalue`. Indicate the attribute type if
  necessary.

## Recipes

### default.rb

Todo: Provide a description for the purpose of this recipe file. What does it
do? When would I use it? Does it invoke other recipes?

## Custom Resources

Todo: You only need to provide documentation for custom resources if your
cookbook actually provides them. Not all cookbooks have custom resources. If you
don't known what this means, then your cookbook probably doesn't have them
either and can omit this documentation.

### resource_name

Todo: Add a description or purpose for this resource. What does it do?

#### Actions

* `:do_something`: Description of this action
* `:another_action`: Description of this action

#### Properties

* `property_name` - Description of this property. What is it used for? What is
  it's default value?
* `property_name2` - Description of this property. What is it used for? What is
  it's default value?

#### Examples

todo: Describe this example and what it will accomplish.

```Ruby
# code samples are helpful
ibm_apm_resource_name 'some value' do
  property_name 'another value'
  property_name2 'foo bar'
  action :do_something
end
```

And don't forgot to show an example for your other actions.

```Ruby
# code samples are helpful
ibm_apm_resource_name 'some value' do
  property_name 'another value'
  property_name2 'foo bar'
  action :another_action
end
```
