namespace WebApplication1.Models;

public class RegisterRequestDto
{
    public enum UserRoles
    {
        Admin,
        User
    }
    public required string UserName { get; set; }
    public required string Email { get; set; }
    public required string Password { get; set; }
    public required UserRoles[] Roles { get; set; }
}