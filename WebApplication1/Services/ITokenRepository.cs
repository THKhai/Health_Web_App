using Microsoft.AspNetCore.Identity;

namespace WebApplication1.Services;

public interface ITokenRepository
{
    string CreateToken(IdentityUser user, List<string> roles);
}  