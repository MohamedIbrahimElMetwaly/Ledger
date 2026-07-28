package entities;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "category", uniqueConstraints = @UniqueConstraint(name = "uq_category_name_per_user", columnNames = {"user_id", "name"}))
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    // Tells Hibernate to run this function just before inserting to DB
    @PrePersist
    protected void onCreate() {
        this.createdAt = Instant.now();
    }

    // Getters and setters

    public Long getId() { return id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Instant getCreatedAt() { return createdAt; }

    public Instant getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Instant deletedAt) { this.deletedAt = deletedAt; }
}
