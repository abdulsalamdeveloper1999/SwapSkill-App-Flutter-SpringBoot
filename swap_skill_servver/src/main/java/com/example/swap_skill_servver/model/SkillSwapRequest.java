package com.example.swap_skill_servver.model;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity // Marks this class as a JPA entity, meaning it will be mapped to a database
        // table.
@Table(name = "skill_swap_request") // Specifies the name of the database table
                                    // (skill_swap_request) that this entity will be mapped to.
public class SkillSwapRequest {

    @Id // Marks the id field as the primary key of the entity.
    @GeneratedValue(strategy = GenerationType.UUID)
    // Specifies that the primary key (id)
    // will be generated automatically using a UUID.
    private UUID id;

    @ManyToOne
    // Indicates a many-to-one relationship between
    // SkillSwapRequest and User. A skill swap request is associated with one
    // sender (User) and one receiver (User).

    @JoinColumn(name = "sender_id", nullable = false)
    // Specifies that the sender_id column in the database is a
    // foreign key referencing the User entity.
    // nullable = false ensures that this
    // field cannot be null.

    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver;

    @ElementCollection
    // Used to map a collection of basic types (Set<String>) as a separate table
    // rather than an entity.
    // The table
    // is linked
    // to SkillSwapRequest
    // using the
    // request_id column.
    @CollectionTable(name = "sender_teach_skills", joinColumns = @JoinColumn(name = "request_id"))
    @Column(name = "skill")
    private Set<String> senderTeachSkills;

    @ElementCollection
    @CollectionTable(name = "sender_learn_skills", joinColumns = @JoinColumn(name = "request_id"))
    @Column(name = "skill")
    private Set<String> senderLearnSkills;

    @Enumerated(EnumType.STRING)
    private RequestStatus status;

    private String message;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Enum for request status
    public enum RequestStatus {
        PENDING,
        ACCEPTED,
        REJECTED,
        CANCELLED
    }

}
