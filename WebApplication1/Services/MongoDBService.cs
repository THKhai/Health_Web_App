using Microsoft.Extensions.Options;
using MongoDB.Driver;
using WebApplication1.Data;
using WebApplication1.Models;

namespace WebApplication1.Services;

public class MongoDBService
{
    // Add a CRUD method to create a new user
    private readonly IMongoCollection<Users> _usersCollection;

    public MongoDBService(IOptions<MongoDBSetting> mongoDBSetting)
    {
        var mongoClient = new MongoClient(mongoDBSetting.Value.ConnectionString);
        var mongoDatabase = mongoClient.GetDatabase(mongoDBSetting.Value.DatabaseName);
        _usersCollection = mongoDatabase.GetCollection<Users>(mongoDBSetting.Value.CollectionName);
    }
    public async Task CreateUserAsync(Users user)
    {
        await _usersCollection.InsertOneAsync(user);
    }
    public async Task<Users> GetUserByIdAsync(string id)
    {
        var filter = Builders<Users>.Filter.Eq(u => u.Id, id);
        return await _usersCollection.Find(filter).FirstOrDefaultAsync();
    }
    public async Task<List<Users>> GetAllUsersAsync()
    {
        return await _usersCollection.Find(_ => true).ToListAsync();
    }
    public async Task UpdateUserAsync(string id, Users user)
    {
        var filter = Builders<Users>.Filter.Eq(u => u.Id, id);
        await _usersCollection.ReplaceOneAsync(filter, user);
    }
    public async Task DeleteUserAsync(string id)
    {
        var filter = Builders<Users>.Filter.Eq(u => u.Id, id);
        await _usersCollection.DeleteOneAsync(filter);
    }
}