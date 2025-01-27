import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techrx/features/comments/domain/entity/comment.dart';
import 'package:techrx/features/comments/domain/repos/comment_repo.dart';

class SupabaseCommentRepo implements CommentRepo {
  @override
  Future<void> addComment(Comment comment) async {
    try {
      final database = Supabase.instance.client.from('comments');
      await database.insert(comment.toMap());
    } catch (e) {
      print('Error inserting comment: $e');
      rethrow; // Optional: Rethrow for higher-level handling
    }
  }

  @override
  Future<void> updateComment(Comment oldComment, Comment newComment) async {
    if (oldComment.id == null) {
      throw Exception("Comment ID is null. Cannot update comment.");
    }

    final database = Supabase.instance.client.from('comments');
    try {
      await database.update({
        'note': newComment.note,
      }).eq('id', oldComment.id!);
    } catch (e) {
      print('Error updating comment: $e');
      throw Exception("Error updating your comment: $e");
    }
  }

  @override
  Future<void> deleteComment(Comment comment) async {
    final database = Supabase.instance.client.from('comments');
    try {
      await database.delete().eq('id', comment.id!);
    } catch (e) {
      print('Error deleting comment: $e');
      throw Exception("Could not delete comment: $e");
    }
  }

  @override
  Stream<List<Comment>> getTicketComment(int? ticketId) {
    final supabase = Supabase.instance.client;
    return supabase
        .from('comments')
        .stream(primaryKey: [
          'ticketId'
        ]) // Listen for changes in the comments table
        .eq(
            'ticketId',
            ticketId ??
                100) // Filter by `ticket_id` (ensure correct column name)
        .order('created_at',
            ascending: false) // Sort by 'created_at' in ascending order
        .map((data) =>
            data.map((commentMap) => Comment.fromMap(commentMap)).toList());
  }
}


/* 

  @override
  Future<void> createTicket(Ticket newTicket) async {
    //database tickets
    final database = Supabase.instance.client.from('tickets');
    await database.insert(newTicket.toMap());
  }


  @override
  Future<void> updateTicket(Ticket oldTicket, Ticket updatedTicket) async {
    if (oldTicket.id == null) {
      // Handle the case when the id is null (you can throw an exception, return early, or show an error)
      throw Exception("Ticket id is null. Cannot update ticket.");
    }

    final database = Supabase.instance.client.from('tickets');

    try {
      await database.update({
        'userName': updatedTicket.userName, // Update fields individually
        'location': updatedTicket.location,
        'contact': updatedTicket.contact,
        'issueDescription': updatedTicket.issueDescription,
        'emergency': updatedTicket.emergency,
        'imageUrl': updatedTicket.imageUrl,
      }).eq('id', oldTicket.id!); // Use the id safely after null check
    } catch (e) {
      // Handle any errors that occur during the update
      throw Exception("Error updating ticket: $e");
    }
  }


  @override
  Future<void> deleteTicket(Ticket ticket) async {
    //database tickets
    final database = Supabase.instance.client.from('tickets');
    await database.delete().eq('id', ticket.id!);
  }

  @override
  Stream<List<Ticket>> fetchTicket(int query) {
    return supabase
        .from('tickets')
        .stream(primaryKey: ['id']) // Listen for changes in the tickets table
        .eq('id', query)
        .map((data) =>
            data.map((ticketMap) => Ticket.fromMap(ticketMap)).toList());
  }


*/