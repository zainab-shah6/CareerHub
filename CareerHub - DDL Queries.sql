if object_id('dbo.Roles', 'U') is null
begin
create table Roles(
RoleID int primary key identity, -- job seeker, employer, or admin
RoleName nvarchar(50) not null
);
end

if object_id('dbo.Users', 'U') is null
begin
create table Users(
UserID int primary key identity,
Name nvarchar(100) not null,
Email nvarchar(100) unique not null,
Password nvarchar(255) not null,
RoleID int foreign key references Roles(RoleID) on delete cascade, -- cascade deletion if role is deleted
Status nvarchar(50) check (Status in ('active', 'inactive', 'suspended')), -- active, inactive, or suspended
CreateDate datetime default getdate() not null
);
end


if object_id('dbo.JobSeekersProfiles', 'U') is null
begin
create table JobSeekersProfiles(
ProfileID int primary key identity,
UserID int foreign key references Users(UserID) on delete cascade, -- cascade de;te if user is deleted
Resume nvarchar(max),
Bio nvarchar(500),
ProfilePicture nvarchar(255), --to store profile picture's URL
IsActive bit default 1 not null
);
end

if object_id('dbo.EmployerProfiles', 'U') is null
begin
create table EmployerProfiles(
ProfileID int primary key identity,
UserID int foreign key references Users(UserID) on delete cascade,
CompanyName nvarchar(100) not null,
Bio nvarchar(50),
ProfilePicture nvarchar(225),
IsActive bit default 1 not null
); 
end

if object_id('dbo.Skills', 'U') is null
begin
create table Skills(
SKillID int primary key identity,
SkillName nvarchar(100) not null
);
end

if object_id('dbo.Jobs', 'U') is null
begin
create table Jobs(
JobID int primary key identity,
EmployerID int foreign key references EmployerProfiles(ProfileID) on  delete cascade,
JobTitle nvarchar(100) not null,
JobDescription nvarchar(max),
Location nvarchar(100),
PostedAt datetime default GETDATE() not null
);
end

if object_id('dbo.JobSeekerSkills', 'U') is null
begin
create table JobSeekerSkills( --many-to-many relationship between job seekers and skills | Job Seekers can possess multiple skills. Skills can be associated with multiple job seekers.
JobSeekerID int foreign key references JobSeekersProfiles(ProfileID) on delete cascade,
SkillID int foreign key references Skills(SkillID) on delete cascade
primary key (JobSeekerID, SkillID)
);
end

if object_id('dbo.Ratings', 'U') is null
begin
create table Ratings(
RatingID int primary key identity,
RatedByUserID int foreign key references Users(UserID) on delete cascade,
RatedUserID int foreign key references Users(UserID) on delete no action,
RatingValue int check (RatingValue between 1 and 5) not null,
CreatedAt datetime default GETDATE() not null
);
end

if object_id('dbo.Reviews', 'U') is null
begin
create table Reviews(
ReviewID int primary key identity,
RatingID int foreign key references Ratings(RatingID) on delete cascade,
ReviewText nvarchar(1000),
CreatedAt datetime default GETDATE() not null
);
end
-- tables for forum posts and comments to manage discussions
if object_id('dbo.ForumPosts', 'U') is null
begin
create table ForumPosts(
PostID int primary key identity,
UserID int foreign key references Users(UserID) on delete cascade,
Title nvarchar(255) not null,
Body nvarchar(max),
CreatedAt datetime default GETDATE() not null
);
end

if object_id('dbo.Comments', 'U') is null
begin
create table Comments(
CommentID int primary key identity,
PostID int foreign key references ForumPosts(PostID) on delete cascade,
UserID int foreign key references Users(UserID) on delete no action,
CommentText nvarchar(1000) not null,
CreatedAt datetime default GETDATE() not null
);
end

if object_id('dbo.Subscriptions', 'U') is null
begin
create table Subscriptions(
SubscriptionID int primary key identity,
EmployerID int foreign key references EmployerProfiles(ProfileID) on delete cascade,
PackageType nvarchar(50) not null,
StartDate datetime not null,
EndDate datetime not null
);
end

if object_id('dbo.Rewards', 'U') is null
begin
create table Rewards(
RewardID int primary key identity,
JobSeekerID int foreign key references JobSeekersProfiles(ProfileID) on delete cascade,
RewardType nvarchar(100) not null,
RewardDate datetime default getdate() not null
);
end

if object_id('dbo.Feedback', 'U') is null
begin
create table Feedback(
FeedbackID int primary key identity,
UserID int foreign key references Users(UserID) on delete cascade,
FeedbackText nvarchar(1000) not null,
CreatedAt datetime default getdate() not null
);
end

if object_id('dbo.ActivityLogs', 'U') is null
begin
create table ActivityLogs(
LogID int primary key identity,
UserID int foreign key references Users(UserID) on delete cascade,
ActivityType nvarchar(100) not null,
ActivityDate datetime default getdate() not null,
FeedbackID int foreign key references Feedback(FeedbackID) on delete no action
);
end






