using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
namespace WebApplication1.Models;

public class Users
{
    [BsonId]
    [BsonRepresentation(BsonType.ObjectId)]
    public string Id { get; set; }
    
    [BsonElement("user_id")]
    public string UserId { get; set; } = null!;
    
    [BsonElement("profile")]
    public UserProfile Profile { get; set; } = null!;
}