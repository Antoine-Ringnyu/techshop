import 'package:techrx/features/comments/domain/entity/comment.dart';

abstract class CommentRepo {
  Stream<List<Comment>> getTicketComment(int ticketId);
  Future<void> addComment(Comment comment);
  Future<void> updateComment(Comment oldComment, Comment newComment);
  Future<void> deleteComment(Comment commentId);
}