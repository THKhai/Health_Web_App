using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace WebApplication1.Models;

public class UserProfile
{
    [BsonElement("full_name")]
    public string FullName { get; set; } = null!;

    [BsonElement("gender")]
    public string Gender { get; set; } = null!;

    [BsonElement("dob")]
    public string Dob { get; set; } = null!;

    [BsonElement("height")]
    public int Height { get; set; }

    [BsonElement("weight")]
    public int Weight { get; set; }

    [BsonElement("bmi")]
    public double Bmi { get; set; }

    [BsonElement("goals")]
    public string Goals { get; set; } = null!;
}