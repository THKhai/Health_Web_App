using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace WebApplication1.Data;

public class AuthContext:IdentityDbContext<IdentityUser,IdentityRole,string>
{
    public AuthContext (DbContextOptions<AuthContext> options) : base(options) {}
}