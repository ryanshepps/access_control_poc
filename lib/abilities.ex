defimpl Canada.Can, for: Atom do
  def can?(nil, :public_action, _resource), do: true
  def can?(_nil, _action, _resource), do: false
end

defimpl Canada.Can, for: CanaryPoc.Models.User do
  alias CanaryPoc.Models.User
  alias CanaryPoc.Models.Organization

  @spec can?(%CanaryPoc.Models.User{}, any(), any()) :: boolean()
  def can?(%User{role: "admin"}, :create, Organization), do: true
  def can?(%User{role: "admin"}, :show, Organization), do: true
  def can?(%User{role: "admin"}, :update, Organization), do: true
  def can?(%User{role: "admin"}, :delete, Organization), do: false

  def can?(_user, _action, _resource), do: false
end
