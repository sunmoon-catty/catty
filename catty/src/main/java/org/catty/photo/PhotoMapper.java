package org.catty.photo;

import java.util.List;

/**
 * @author dbsehdghks45@naver.com
*/
public interface PhotoMapper {
    public Photo selectPhoto(Photo photo) throws Exception;
    public int insertPhoto(Photo photo) throws Exception;
    public int updatePhoto(Photo photo) throws Exception;
    public int deletePhoto(Photo photo) throws Exception;
}